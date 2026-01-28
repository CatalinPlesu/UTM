use macroquad::camera::*;	
use macroquad::file::*;	
use macroquad::input::*;	
use macroquad::material::*;	
use macroquad::math::*;	
use macroquad::models::*;	
use macroquad::shapes::*;	
use macroquad::text::*;	
use macroquad::texture::*;	
use macroquad::time::*;	
use macroquad::window::*;	
use macroquad::color::colors::*;	
use macroquad::color::Color;	
use macroquad::experimental::*;	
use macroquad::logging::*;	
use macroquad::color_u8;
use macroquad::window;
use rand::Rng;

fn window_conf() -> window::Conf {
    window::Conf {
        window_title: "GC Lab 1".to_owned(),
        high_dpi: true,
        ..Default::default()
    }
}

#[macroquad::main(window_conf)]
async fn main() {
    macroquad::file::set_pc_assets_folder("assets");

    let ox = screen_width() / 2.0;
    let oy = screen_height() / 2.0;


    let mut rng = rand::thread_rng();
    let n: usize = rng.gen_range(3, 9);
    let mut col: Vec<Color> = Vec::new();
    let mut width_modifier: Vec<f32> = Vec::new();
    let mut height_modifier: Vec<f32> = Vec::new();
    let mut thickness: Vec<f32> = Vec::new();
    for i in 0..n {
        col.push(rand_color());
        width_modifier.push(rng.gen_range(1.1, 9.0));
        height_modifier.push(rng.gen_range(1.0, 2.0));
        thickness.push(rng.gen_range(1.0, 4.0));
    }


    let mut unsaved = true;
    loop {
        clear_background(BLACK);

        // draw_diamond(ox, oy, 1.1, 1.75, 1.5, PINK);
        // draw_diamond(ox, oy, 1.2, 1.4, 2.0, ORANGE);
        // draw_diamond(ox, oy, 1.6, 1.25, 2.0, BLUE);
        // draw_diamond(ox, oy, 100.0, 1.0, 1.5, RED);

        for i in 0..n {
            draw_diamond(ox, oy, 
                         width_modifier[i],
                         height_modifier[i], 
                         thickness[i], 
                         col[i]);
        }


        if unsaved {
            let image = get_screen_data();
            image.export_png(&format!("__out/diamonds/diamond_{}.png", rng.gen::<i32>()));
            unsaved = false;
        }
        draw_text(&get_fps().to_string(), screen_width() - 30.0, 20.0, 20.0, BLACK);
        window::next_frame().await
    }
}
fn rand_color() -> Color {
    let mut rng = rand::thread_rng();
    let n1: u8 = rng.gen();
    let n2: u8 = rng.gen();
    let n3: u8 = rng.gen();
    Color::from_rgba(n1, n2, n3, 255)
}

fn draw_diamond(ox: f32, oy: f32, d: f32, z: f32, thickness: f32, color: Color) {
    // let thickness = 2.0;
    // let color = ORANGE;
    // let d = 100.0;
    // let z = 1.0;

    //left to right
    for i in (oy as i32..(screen_height()/z) as i32).step_by(20) {
        draw_line(ox/d, oy, ox, i as f32, thickness, color);
        draw_line(ox, i as f32, screen_width()-ox/d, oy, thickness, color);
        draw_line(ox/d, oy, ox,2.0 * oy - i as f32, thickness, color);
        draw_line(ox, 2.0 * oy - i as f32, screen_width()-ox/d, oy, thickness, color);
    }
    //top to bottom
    for i in ((ox/d) as i32..(screen_width()-ox/d) as i32).step_by(20) {
        draw_line(ox,  2.0 * oy - screen_height()/z, i as f32, oy, thickness, color);
        draw_line(i as f32, oy, ox, screen_height() - (2.0 * oy - screen_height()/z), thickness, color);
        // draw_line(ox, 0.0, 2.0 * ox - i as f32, oy, thickness, color);
        // draw_line(2.0 * ox - i as f32, oy, ox, screen_height(), thickness, color);
    }
}
