var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages().AddRazorRuntimeCompilation();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}"
);

app.MapControllerRoute(
    name: "HomeS1",
    pattern: "HomeS1/{action=Index}/{id?}",
    defaults: new { controller = "HomeS1" }
);

app.MapControllerRoute(
    name: "HomeS2",
    pattern: "HomeS2/{action=Index}/{id?}",
    defaults: new { controller = "HomeS2" }
);

app.MapControllerRoute(
    name: "HomeS3",
    pattern: "HomeS3/{action=Index}/{id?}",
    defaults: new { controller = "HomeS3" }
);

app.MapControllerRoute(
    name: "Login",
    pattern: "Login/{action=Index}/{id?}",
    defaults: new { controller = "Login" }
);

app.UseAuthorization();

app.Run();

