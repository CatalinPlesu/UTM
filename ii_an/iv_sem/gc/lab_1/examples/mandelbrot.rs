use macroquad::color::colors::*;
use macroquad::color::Color;
use macroquad::input::*;
use macroquad::math::*;
use macroquad::texture::*;
use macroquad::window::*;
use rand::Rng;

fn gen_color_coef() -> f32 {
    let mut rng = rand::thread_rng();
    rng.gen_range(1.4, 8.0)
}

struct Settings {
    r: f32,
    g: f32,
    b: f32,
    max_iter: i32,
    colors: Vec<Color>,
}

fn mandelbrot(x: f64, y: f64, set: &Settings) -> Color {
    let mut zx = 0f64;
    let mut zy = 0f64;

    let mut i = 0;

    while i < set.max_iter && (zx * zx + zy * zy) <= 4f64 {
        let zx_temp = zx * zx - zy * zy + x;
        zy = 2f64 * zx * zy + y;
        zx = zx_temp;
        i += 1;
    }

    if i == set.max_iter {
        return BLACK;
    } else {

        return set.colors[i as usize];
        // let mut i = i as f32;
        // if i > 255. {
        //     i -= 255.
        // }
        // return Color::new(set.r * i / 255., set.g * i / 255., set.b * i / 255., 1.0);
    }
}

fn mandelbrot_image(x_0: f32, y_0: f32, zoom: f32, set: &Settings) -> Image {
    let mut screen = Image::gen_image_color(screen_width() as u16, screen_height() as u16, WHITE);

    let ox = screen_width() / 2.0;
    let oy = screen_height() / 2.0;

    let unit;
    if ox < oy {
        unit = ((zoom * 2.) / screen_width()).abs();
    } else {
        unit = ((zoom * 2.) / screen_height()).abs();
    };

    for xx in 0..screen_width() as u32 {
        for yy in 0..screen_height() as u32 {
            let x = (xx as f64 - ox as f64) * unit as f64 + x_0 as f64;
            let y = (yy as f64 - oy as f64) * unit as f64 + y_0 as f64;
            screen.set_pixel(xx, yy, mandelbrot(x, y, set));
        }
    }
    return screen;
}

#[macroquad::main("Texture")]
async fn main() {
    let mut set: Settings = Settings {
        r: gen_color_coef(),
        g: gen_color_coef(),
        b: gen_color_coef(),
        max_iter: 55,
        colors: Vec::<Color>::new(),
    };


    let mut rng = rand::thread_rng();
    for i in 0..1000 {
        set.colors.push(Color::new(
            rng.gen_range(25., 255.) / 255.,
            rng.gen_range(25., 255.) / 255.,
            rng.gen_range(25., 255.) / 255.,
            1.0,
        ));
    }

    let mut rng = rand::thread_rng();
    let mut x_0 = 0.;
    let mut y_0 = 0.;
    let mut zoom = 2.0; // lower increase zoom
    let zoom_mult = 0.4; // lower increase zoom
    let dist = 0.2;
    let mut screen = mandelbrot_image(x_0, y_0, zoom, &set);

    loop {
        clear_background(LIGHTGRAY);

        if is_key_down(KeyCode::D) {
            x_0 += dist * zoom;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::A) {
            x_0 -= dist * zoom;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::S) {
            y_0 += dist * zoom;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::W) {
            y_0 -= dist * zoom;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::E) {
            zoom -= zoom_mult * zoom;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::Q) {
            zoom += zoom_mult * zoom;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::R) {
            set.max_iter += 25;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_key_down(KeyCode::F) {
            set.max_iter -= 25;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }
        if is_mouse_button_down(MouseButton::Left) {
            let mouse = mouse_position();
            let ox = screen_width() / 2.0;
            let oy = screen_height() / 2.0;
            let unit;
            if ox < oy {
                unit = ((zoom * 2.) / screen_width()).abs();
            } else {
                unit = ((zoom * 2.) / screen_height()).abs();
            };
            x_0 = (mouse.0 - ox) * unit + x_0;
            y_0 = (mouse.1 - oy) * unit + y_0;
            screen = mandelbrot_image(x_0, y_0, zoom, &set);
        }

        let texture = Texture2D::from_image(&screen);
        draw_texture(texture, 0.0, 0.0, WHITE);

        if is_key_down(KeyCode::Enter) {
            let image = get_screen_data();
            image.export_png(&format!(
                "__out/mandelbrot/mandelbrot_{}.png",
                rng.gen::<i32>()
            ));
            return;
        }
        next_frame().await
    }
}
