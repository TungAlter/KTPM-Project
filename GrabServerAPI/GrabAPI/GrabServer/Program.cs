﻿global using GrabServerCore.Models;
global using GrabServerData;
using Microsoft.OpenApi.Models;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Swashbuckle.AspNetCore.Filters;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using GrabServer.Services.AccountService;
using GrabServer.Services.BookingService;
using GrabServer.Services.DriverService;
using AutoMapper;
using GrabServer.EventProcess;
using GrabServer.RabbitMQ;
using GrabServer.Services.WeatherService;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Thêm service
builder.Services.AddScoped<IAccountService, AccountService>();
builder.Services.AddScoped<IBookingService, BookingService>();
builder.Services.AddScoped<IDriverService, DriverSerivce>();
builder.Services.AddScoped<IWeatherService, WeatherService>();
//builder.Services.AddSingleton<IEventProcess, EventProcess>();
//builder.Services.AddHostedService<MessageBusSubscriber>();
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
builder.Services.AddHttpContextAccessor();
builder.Services.AddServicesData();
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(option =>
{
    option.TokenValidationParameters = new TokenValidationParameters
    {
        // tự cấp Token
        ValidateIssuer = false,
        ValidateAudience = false,

        // Ký vào token
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8
                .GetBytes(builder.Configuration.GetSection("AppSettings:SecrectKey").Value!)),
        ClockSkew = TimeSpan.Zero
    };
});


builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
    {
        Description = "Standard Authorization header using the Bearer scheme (\"bearer {token}\")",
        In = ParameterLocation.Header,
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey
    });

    options.OperationFilter<SecurityRequirementsOperationFilter>();
});

builder.Services.AddCors(options => options.AddDefaultPolicy(policy => policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()));


// kết nối DB sử dụng connectionString trong appsetting.json
builder.Services.AddUnitOfWork(options => options.UseSqlServer(builder.Configuration.GetConnectionString("MyDB")));
var configuration = new ConfigurationBuilder()
    .SetBasePath(builder.Environment.ContentRootPath)
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .Build();
//string connectionString = configuration.GetConnectionString("MyDB");
//builder.Services.AddDbContext<GrabDataContext>(option =>
//{
//    option.UseSqlServer(connectionString);
//});
//
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();
app.UseCors();
app.MapControllers();

app.Run();
