using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

// builder.Services.AddCors(options =>
// {
//     options.AddDefaultPolicy(builder =>
//     {
//         builder.WithOrigins("http://localhost:5236") // Thay bằng nguồn gốc của trang web của bạn
//                .AllowAnyMethod()
//                .AllowAnyHeader();
//     });
// });

// app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.MapRazorPages();
app.UseAuthorization();

// app.MapRazorPages();



app.Run();

var configuration = app.Configuration;
var connectionString = configuration.GetConnectionString("DefaultConnection");

// Create a SqlConnectionStringBuilder
var sqlConnectionStringBuilder = new SqlConnectionStringBuilder(connectionString);
