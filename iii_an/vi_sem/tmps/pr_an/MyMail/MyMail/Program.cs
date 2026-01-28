

var builder = WebApplication.CreateBuilder(args);
var tempPath = "D:\\Docs\\UTM Folder\\Anul 3\\TMPS\\Proiect Curs\\MyMail\\temp";

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/App/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=App}/{action=Server}/{id?}");

if (System.IO.Directory.Exists(tempPath) == true)
{
    System.IO.Directory.Delete(tempPath, true);
}

System.IO.Directory.CreateDirectory(tempPath);

app.Run();
