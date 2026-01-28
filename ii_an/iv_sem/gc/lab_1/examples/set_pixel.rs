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

#[macroquad::main("Texture")]
async fn main() {
    let mut screen = Image::gen_image_color(screen_width() as u16, screen_height() as u16, WHITE);
    let mut rng = rand::thread_rng();

    for x in 0..screen_width() as u32{
        for y in 0..screen_height() as u32{
            screen.set_pixel(x, y, Color::new(x as f32 /255., y as f32 /255., 0.23, 1.0));
        }
    }

    for x in 0..screen_width() as u32{
        let y =  (((x as f32).sin() + 20.0) * 10.0) as u32;
        for i in 0..3 {
            screen.set_pixel(x, y + i, BLACK);
        }

        let y =  (((x as f32).cos() + 80.0) * 5.0) as u32;
        for i in 0..3 {
            screen.set_pixel(x, y + i, BLACK);
        }
    }

    loop {
        clear_background(LIGHTGRAY);

        let texture = Texture2D::from_image(&screen);

        draw_texture(texture, 0.0, 0.0, WHITE);

        // let image = get_screen_data();
        // image.export_png(&format!("x_out/triangle_{}.png", rng.gen::<i32>()));

        next_frame().await
    }
}
