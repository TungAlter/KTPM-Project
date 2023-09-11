namespace GrabServer.Services.WeatherService
{
    public interface IWeatherService
    {
        public string GetWeatherNow(double longi, double lati);
    }
}
