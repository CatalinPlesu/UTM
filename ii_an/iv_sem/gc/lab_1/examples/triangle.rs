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
        ..Default::default()
    }
}
 
// Sierpinski triangle
#[warn(dead_code)]
#[derive(Debug)]
struct Triangle {
    c: Vec2,
    pos: [Vec2; 3],
    thickness: f32,
    height: f32,
    edge: f32,
    color: Color,
}

impl Triangle {

    pub fn new(pos: Vec2, edge: f32, thickness: f32, color: Color) -> Self {
        let c = pos;
        let h = (edge.powf(2.0) - (edge/2.0).powf(2.0)).sqrt();
        let p3 = macroquad::math::Vec2::new(pos.x + edge/2.0, pos.y - h/2.0);
        let p2 = macroquad::math::Vec2::new(pos.x - edge/2.0, pos.y - h/2.0);
        let p1 = macroquad::math::Vec2::new(pos.x, pos.y + h/2.0);
        let height = h;
        let pos = [p1, p2, p3];

        let mut rng = rand::thread_rng();
        let n1: u8 = rng.gen();
        let n2: u8 = rng.gen();
        let n3: u8 = rng.gen();
        let color = Color::from_rgba(n1, n2, n3, 255);
        Self {c, pos, thickness, height, edge, color }
    }

    pub fn neighbors(&self) -> Vec<Triangle> {

    let t1 = Triangle::new(
        macroquad::math::Vec2::new(self.c.x - self.edge/2.0, self.c.y + self.height/4.0),
                    self.edge/2.0,
                    2.0,
                    YELLOW);
    let t2 = Triangle::new(
        macroquad::math::Vec2::new(self.c.x + self.edge/2.0, self.c.y + self.height/4.0),
                    self.edge/2.0,
                    2.0,
                    BLUE);
    let t3 = Triangle::new(
        macroquad::math::Vec2::new(self.c.x, self.c.y - self.height*3.0/4.0),
                    self.edge/2.0,
                    2.0,
                    ORANGE);
    vec![t1, t2, t3]
    }
 
    pub fn draw_hallow(&self) {
        draw_triangle_lines(self.pos[0], self.pos[1], self.pos[2], self.thickness, self.color);
    }

    pub fn draw_full(&self) {
        draw_triangle(self.pos[0], self.pos[1], self.pos[2], self.color);
    }
}

#[macroquad::main(window_conf)]
async fn main() {
    macroquad::file::set_pc_assets_folder("assets");
    let mut rng = rand::thread_rng();

    let ox = screen_width() / 2.0;
    let oy = screen_height() / 2.0;

    let mut list: Vec<Triangle> = Vec::new();

    let edge: f32 = rng.gen_range(200.0, 400.0);
    let h = (edge.powf(2.0) - (edge/2.0).powf(2.0)).sqrt();
    let mut queue = vec![Triangle::new(macroquad::math::Vec2::new(ox, oy + h/2.0), edge, 2.0, RED)];

    loop {
        let mut temp: Vec<Triangle> = Vec::new();
        for t in &queue {
            temp.extend(t.neighbors());
        }
        list.extend(queue);
        queue = temp;
        if queue[0].edge <= 1.5 {
            break;
        }
    }
    let mut unsaved = true;
    loop {
        clear_background(LIGHTGRAY);
        if unsaved {
            clear_background(WHITE);
            for t in &list {
            // for t in &queue {
                t.draw_hallow();
            }
            let image = get_screen_data();
            image.export_png(&format!("__out/triangles/triangle_{}.png", rng.gen::<i32>()));
            unsaved = false;
        }

        draw_page(ox, oy);

        for t in &list {
            // t.draw_full();
            t.draw_hallow();
        }

        draw_text(&get_fps().to_string(), screen_width() - 30.0, 20.0, 20.0, BLACK);
        window::next_frame().await
    }
}

fn draw_page(ox: f32, oy: f32) {

    for i in (oy as i32..screen_height() as i32).step_by(20) {
        draw_line(0.0, i as f32, screen_width(), i as f32, 1.0, GRAY);
        draw_line(0.0, oy - (i as f32 - oy), screen_width(), oy - (i as f32 - oy), 1.0, GRAY);
    }

    for i in (ox as i32..screen_width() as i32).step_by(20) {
        draw_line(i as f32, 0.0, i as f32, screen_height(), 1.0, GRAY);
        draw_line(ox - (i as f32 - ox), 0.0, ox - (i as f32 - ox), screen_height(), 1.0, GRAY);
    }

    draw_line(0.0, oy, screen_width(), oy, 1.0, BLUE);
    draw_line(ox, 0.0, ox, screen_height(), 1.0, BLUE);

}
