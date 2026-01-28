#![allow(warnings)]

use macroquad::prelude::*;

use macroquad::ui::{
    hash, root_ui,
    widgets::{self, Group},
    Drag, Skin, Ui,
};

fn window_conf() -> Conf {
    Conf {
        window_title: "Main".to_owned(),
        window_width: 640,
        window_height: 480,
        ..Default::default()
    }
}
#[macroquad::main(window_conf)]
async fn main() {
    let mut cohesion_val: f32 = 1.0;
    let mut separation_val: f32 = 100.;
    let mut allign_val: f32 = 0.;

    let mut velocity_val: f32 = 5.;
    let mut fov_val: f32 = 20.;

    loop {
        clear_background(BLACK);
        //sliders to get vals

        widgets::Window::new(hash!(), vec2(340., 330.), vec2(300., 150.))
            .label("Values")
            .movable(true)
            .ui(&mut *root_ui(), |ui| {
                ui.slider(hash!(), "Velocity", -10f32..10f32, &mut velocity_val);
                ui.slider(hash!(), "Field Of View", 10f32..100f32, &mut fov_val);
                ui.slider(hash!(), "Cohesion", 1.0f32..50.0f32, &mut cohesion_val);
                ui.slider(hash!(), "Separation", 10f32..100f32, &mut separation_val);
                ui.slider(hash!(), "Allignment", 10f32..100f32, &mut allign_val);
            });
        next_frame().await;
    }
}

