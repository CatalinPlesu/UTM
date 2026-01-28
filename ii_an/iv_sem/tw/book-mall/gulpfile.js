const gulp =  require("gulp")
const ejs = require("gulp-ejs")
const rename = require("gulp-rename")
const sass = require('gulp-sass')(require('sass'));
const browserSync = require('browser-sync').create();

var dir = {
    assets: {
        // jquery   : './node_modules/jquery/dist',
        bootstrap: './node_modules/bootstrap-honoka/dist/js'
    },
    src: {
        ejs  : './src/ejs',
        scss : './src/scss',
        js   : './src/js',
        img  : './src/img',
        fonts  : './src/fonts',
        data  : './src/data'
    },
    dist: {
        html : './dist',
        css  : './dist/css',
        js   : './dist/js',
        img  : './dist/img',
        fonts  : './dist/fonts'
    }
};

gulp.task("ejs", async function() {
    var data = require(dir.src.data + '/data.json');
    gulp.src(
        [dir.src.ejs + "/**/*.ejs", "!" + dir.src.ejs + "/**/_*.ejs"] 
    )
        .pipe(ejs(data))
        .pipe(rename({ extname: ".html" }))
        .pipe(gulp.dest(dir.dist.html))
});

gulp.task("sass", async function() {
	return gulp.src([dir.src.scss + "/**/*.scss"])
    .pipe(sass().on('error',sass.logError))
	.pipe(gulp.dest(dir.dist.css))
    .pipe(browserSync.stream());
});

gulp.task("js", async function() {
	return gulp.src([dir.src.js + "/**/*.js"])
		.pipe(gulp.dest(dir.dist.js)); 
});

gulp.task("fonts", async function() {
	return gulp.src([dir.src.fonts + "/**/*.ttf"])
		.pipe(gulp.dest(dir.dist.fonts)); 
});

gulp.task("img", async function() {
	return gulp.src([dir.src.img + "/**/*.+(jpg|jpeg|png|gif|svg)"])
		.pipe(gulp.dest(dir.dist.img)); 
});

async function watch() {
    (gulp.series("ejs", "sass", "js", "fonts", "img")());

    browserSync.init({
        server: {
            baseDir: dir.dist.html,
            index: "/index.html"
        }
    });

	gulp.watch(dir.src.ejs + "/**/*.ejs").on('change', 
        gulp.series( "ejs", browserSync.reload));

	gulp.watch(dir.src.data + "/**/*.json").on('change', 
        gulp.series( "ejs", browserSync.reload));

    gulp.watch(dir.src.scss + "/**/*.scss").on('change', 
        gulp.series( "sass", browserSync.reload));

    gulp.watch(dir.src.js + "/**/*.js").on('change', 
        gulp.series( "js", browserSync.reload));

    gulp.watch(dir.src.fonts + "/**/*.ttf").on('change', 
        gulp.series( "fonts", browserSync.reload));

    gulp.watch(dir.src.img + "/**/*.+(jpg|jpeg|png|gif|svg)").on('change', 
        gulp.series( "img", browserSync.reload));
}

exports.default = watch;
