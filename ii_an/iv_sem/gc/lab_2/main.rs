use macroquad::color::colors::*;
use macroquad::color::Color;
use macroquad::input::*;
use macroquad::shapes::*;
use macroquad::texture::*;
use macroquad::window;
use macroquad::window::*;

use egui;
use num;
// use rand::Rng;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

mod colorschemes;

#[derive(Clone, Debug)]
struct Point<T> {
    x: T,
    y: T,
}

impl Point<f64> {
    fn to_world(&self, singl: &Singleton) -> Point<f64> {
        let unit = map_screen_to_world(&singl);
        Point::<f64> {
            x: (self.x - singl.offset.1.x as f64 - screen_width() as f64 / 2f64) * unit
                + singl.center.x,
            y: -(self.y - singl.offset.1.y as f64 - screen_height() as f64 / 2f64) * unit
                + singl.center.y,
        }
    }
}

#[derive(Clone, Debug)]
struct Singleton {
    power: f64,
    scale: f64,
    max_iter: usize,
    colorscheme: usize,
    pallet: Vec<Color>,
    center: Point<f64>,
    julia: Point<f64>,
    offset: (Point<f32>, Point<f32>),
    refresh: bool,
    last_refresh: Instant,
    refresh_limit: u64,
    mouse_click: bool,
    egui: bool,
    animation: bool,
    animation_unit: f64,
    threads: usize,
    bands: usize,
}

impl Default for Singleton {
    fn default() -> Singleton {
        Singleton {
            power: 2.,
            scale: 1.,
            max_iter: 55,
            colorscheme: 0,
            pallet: Vec::new(),
            center: Point { x: 0., y: 0. },
            julia: Point { x: 0., y: 0. },
            offset: (Point { x: 0., y: 0. }, Point { x: 0., y: 0. }),
            refresh: false,
            last_refresh: Instant::now(),
            refresh_limit: 100,
            mouse_click: false,
            egui: true,
            animation: false,
            animation_unit: 0.01,
            threads: 8,
            bands: 32,
        }
    }
}

impl Singleton {
    fn generate_colors(&mut self) {
        let colorscheme = colorschemes::colorschemes()[self.colorscheme].clone();
        self.pallet = Vec::new();
        let color = self.max_iter / (colorscheme.len() - 1);
        for i in 0..(colorscheme.len() - 1) {
            for j in 0..color {
                self.pallet.push(Color::new(
                    colorscheme[i].r
                        + (colorscheme[i + 1].r - colorscheme[i].r) * (j as f32 / color as f32),
                    colorscheme[i].g
                        + (colorscheme[i + 1].g - colorscheme[i].g) * (j as f32 / color as f32),
                    colorscheme[i].b
                        + (colorscheme[i + 1].b - colorscheme[i].b) * (j as f32 / color as f32),
                    colorscheme[i].a
                        + (colorscheme[i + 1].b - colorscheme[i].b) * (j as f32 / color as f32),
                ));
            }
        }
        while self.pallet.len() <= self.max_iter {
            self.pallet.push(BLACK);
        }
    }
}

fn mandelbrot(c: num::complex::Complex<f64>, singl: &Singleton) -> usize {
    let mut z = num::complex::Complex::<f64>::new(singl.julia.x, singl.julia.y);
    let mut i: usize = 0;
    while i < singl.max_iter && z.l1_norm() <= 4f64 {
        z = z.powf(singl.power) + c;
        i += 1;
    }
    return i;
}
fn map_screen_to_world(singl: &Singleton) -> f64 {
    let world_unit: f64;
    if screen_width() < screen_height() {
        world_unit = 4f64 / (screen_width() as f64 * singl.scale);
    } else {
        world_unit = 4f64 / (screen_height() as f64 * singl.scale);
    }
    return world_unit;
}

fn fractal(singl: &Singleton) -> Vec<Texture2D> {
    let mut bands = Vec::new();
    for i in 0..singl.bands {
        bands.push(i);
    }

    let mut images = Vec::new();
    let mut band_height = screen_height() as usize / singl.bands;
    band_height += band_height * singl.bands / 10;
    for _ in 0..singl.bands {
        images.push(Image::gen_image_color(
            screen_width() as u16,
            band_height as u16,
            WHITE,
        ));
    }

    let bands_mutex = Arc::new(Mutex::new(bands));
    let images_mutex = Arc::new(Mutex::new(images));
    let singl_mutex = Arc::new(singl.clone());

    let mut handles = Vec::new();
    for _ in 0..singl.threads {
        let singl_clone = Arc::clone(&singl_mutex);
        let bands_clone = Arc::clone(&bands_mutex);
        let images_clone = Arc::clone(&images_mutex);
        let handle = thread::spawn(move || {
            let local_singl = singl_clone;
            loop {
                let mut bands = bands_clone.lock().unwrap();
                if bands.len() == 0 {
                    break;
                }
                let index = bands.remove(0);
                drop(bands);

                let images = images_clone.lock().unwrap();
                let width = images[index].width();
                let height = images[index].height();
                drop(images);

                let mut fractal = Image::gen_image_color(width as u16, height as u16, WHITE);

                for x in 0..screen_width() as u32 {
                    for y in 0..height as u32 {
                        let point = Point::<f64> {
                            x: x as f64,
                            y: (index * height) as f64 + y as f64,
                        }
                        .to_world(&local_singl);
                        let c = num::complex::Complex::<f64>::new(point.x, point.y);

                        let iter = mandelbrot(c, &local_singl);

                        fractal.set_pixel(x, y, local_singl.pallet[iter]);
                    }
                }

                let mut images = images_clone.lock().unwrap();
                images[index] = fractal;
                drop(images);
                thread::sleep(Duration::from_millis(1));
            }
        });
        handles.push(handle);
    }

    for h in handles {
        h.join().unwrap();
    }

    let mut textures = Vec::new();
    let images_clone = Arc::clone(&images_mutex);
    let images = images_clone.lock().unwrap();
    for i in 0..singl.bands {
        textures.push(Texture2D::from_image(&images[i]));
    }
    drop(images);
    return textures;
}

fn draw_menus(singl: &mut Singleton) {
    if singl.egui {
        egui_macroquad::ui(|egui_ctx| {
            egui::Window::new("Settings").show(egui_ctx, |ui| {
                ui.add(egui::Slider::new(&mut singl.scale, 1f64..=1_000_000f64).text("Zoom"));
                ui.add(egui::Slider::new(&mut singl.max_iter, 0..=1_000).text("Max iterations"));
                ui.add(egui::Slider::new(&mut singl.power, 0.0..=100.0).text("Power"));
                ui.add(egui::Slider::new(&mut singl.threads, 1..=16).text("Threads"));
                ui.add(
                    egui::Slider::new(&mut singl.animation_unit, 0.0001..=0.1)
                        .text("Animation unit"),
                );
                ui.add(
                    egui::Slider::new(&mut singl.refresh_limit, 10..=10000).text("Redraw delay"),
                );

                if ui.button("Refresh").clicked() {
                    singl.refresh = true;
                    singl.mouse_click = false;
                    singl.offset = (Point { x: 0., y: 0. }, Point { x: 0., y: 0. });
                }
                if ui.button("Animation on/off").clicked() {
                    singl.animation = !singl.animation;
                }
            });

            egui::Window::new("Debugg info").show(egui_ctx, |ui| {
                ui.label(format!("Scale: {}", singl.scale));
                ui.label(format!("Iterations: {}", singl.max_iter));
                ui.label(format!("Refresh: {}", singl.refresh));
                ui.label(format!("Mouse click: {}", singl.mouse_click));

                ui.collapsing("Positions", |ui| {
                    ui.label(format!("Center: ({}, {})", singl.center.x, singl.center.y));
                    ui.label(format!(
                        "Offset: ({}, {}), ({}, {})",
                        singl.offset.0.x, singl.offset.0.y, singl.offset.1.x, singl.offset.1.y
                    ));
                    ui.label(format!("Mouse position: {:?}", mouse_position()));
                    ui.label(format!(
                        "World position: {:?}",
                        Point::<f64> {
                            x: mouse_position().0 as f64,
                            y: mouse_position().1 as f64
                        }
                        .to_world(&singl)
                    ));
                });

                ui.collapsing("Colors", |ui| {
                    ui.monospace(format!("{:#?}", singl.pallet.len()));
                });

                if ui.button("Reset").clicked() {
                    *singl = Singleton {
                        ..Default::default()
                    };
                }
                if ui.button("Center").clicked() {
                    singl.center = Point::<f64> { x: 0., y: 0. };
                    singl.offset = (Point { x: 0., y: 0. }, Point { x: 0., y: 0. });
                    singl.mouse_click = false;
                }
            });
        });
        egui_macroquad::draw();
    }
}

fn user_input(singl: &mut Singleton) {
    if singl.refresh {
        return;
    }
    let xrest = 300.;
    let yrest = 400.;
    if singl.egui {
        draw_rectangle(0., 0., xrest, yrest, Color::new(0., 0., 0., 0.2));
    }
    if mouse_position().0 > xrest || mouse_position().1 > yrest || !singl.egui {
        if is_mouse_button_pressed(MouseButton::Right) {
            let mouse = mouse_position();
            singl.julia = Point::<f64> {
                x: mouse.0 as f64,
                y: mouse.1 as f64,
            }
            .to_world(&singl);
            singl.refresh = true;
        }
        if is_mouse_button_pressed(MouseButton::Left) && !singl.mouse_click {
            let mouse = mouse_position();
            singl.center = Point::<f64> {
                x: mouse.0 as f64,
                y: mouse.1 as f64,
            }
            .to_world(&singl);
            singl.refresh = true;
        }

        if mouse_wheel().1 != 0. {
            singl.scale += singl.scale * (mouse_wheel().1 / 10.) as f64;
            // singl.refresh = true;
            singl.last_refresh = Instant::now();
        }
    }

    if is_key_pressed(KeyCode::Enter) {
        singl.refresh = true;
    }

    if is_key_pressed(KeyCode::Escape) {
        singl.egui = !singl.egui;
    }

    if is_key_pressed(KeyCode::Space) {
        singl.animation = !singl.animation;
    }

    if is_key_pressed(KeyCode::Tab) {
        singl.colorscheme += 1usize;
        if singl.colorscheme >= colorschemes::colorschemes().len() {
            singl.colorscheme = 0usize;
        }
        singl.generate_colors();
        singl.refresh = true;
    }
}

#[macroquad::main(window_conf)]
async fn main() {
    let mut singl = Singleton {
        power: 2.,
        egui: false,
        ..Default::default()
    };
    singl.generate_colors();

    let mut textures = fractal(&singl);

    loop {
        clear_background(LIGHTGRAY);

        if singl.last_refresh.elapsed().as_millis() > singl.refresh_limit as u128 {
            singl.refresh = true;
        }

        if singl.refresh {
            if singl.pallet.len() < singl.max_iter {
                singl.generate_colors();
            }

            textures = fractal(&singl);

            singl.last_refresh = Instant::now();
            singl.refresh = false;
        }

        if singl.animation {
            singl.power += singl.animation_unit;
        }

        for i in 0..singl.bands {
            draw_texture(textures[i], 0., i as f32 * textures[i].height(), WHITE);
        }

        user_input(&mut singl);
        draw_menus(&mut singl);

        window::next_frame().await
    }
}

fn window_conf() -> window::Conf {
    window::Conf {
        window_title: "GC Lab 2".to_owned(),
        fullscreen: true,
        ..Default::default()
    }
}
