using System;
using System.Net.Http;
using System.Threading.Tasks;
using static System.Net.WebRequestMethods;

namespace GrabServer.Services.WeatherService
{
    public class WeatherService : IWeatherService
    {
        //https://api.openweathermap.org/data/2.5/onecall?lat=10.762542669607527&lon=106.6823583822494&
        //exclude=hourly,daily,minutely&units=metric&appid=ef7e5c835d0d48e7af67eef72eb9d421
        public string GetWeatherNow(double longi, double lati)
        {
            using var httpClient = new HttpClient();
            string url = "https://api.openweathermap.org/data/2.5/onecall?lat=" + lati.ToString() + "&lon=" + longi.ToString() + "&exclude=hourly,daily,minutely&units=metric&appid=ef7e5c835d0d48e7af67eef72eb9d421";
            var response = httpClient.GetAsync(url);
            //response.EnsureSuccessStatusCode();
            var responseBody = response.Result.Content.ReadAsStringAsync().Result;
            Console.WriteLine(responseBody);
            var res = System.Text.Json.JsonSerializer.Deserialize<WeatherResponse>(responseBody);
            Console.WriteLine(res.current.weather[0].main);
            return res.current.weather[0].main;
        }
    }
}
