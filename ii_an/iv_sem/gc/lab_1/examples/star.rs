use macroquad::prelude::*;
use macroquad::window;

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

    loop {
        clear_background(WHITE);

        for x in (0..(screen_width() as u32)).step_by(50) {
            for y in (0..(screen_height() as u32)).step_by(50) {
                if x == 0 || y == 0 {
                    let _x = x as f32;
                    let _y = y as f32;
                    draw_line(_x, _y, screen_width() - _x, screen_height() - _y, 1.0, RED);
                }
            }
        }

        draw_text(&get_fps().to_string(), screen_width() - 30.0, 20.0, 20.0, BLACK);
        window::next_frame().await
    }
}
