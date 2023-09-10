using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using CallCenter_MVC.Models;
using CallCenter_MVC.DTOs;

namespace CallCenter_MVC.Controllers
{
    public class HomeS3Controller : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly string _apiUrl = "http://localhost:5236/api/Booking/received";

        public HomeS3Controller(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            try {        
                    var httpClient = _httpClientFactory.CreateClient();
                    var response = await httpClient.GetAsync(_apiUrl);
                    Console.WriteLine($"State Code: {response.StatusCode}");
                    if (response.StatusCode == HttpStatusCode.OK) {
                        var content = await response.Content.ReadAsStringAsync();

                        var receivedBooking = JsonConvert.DeserializeObject<IEnumerable<ReceivedBookingDTO>>(content);  
                    
                        var listBooking = new List<ReceivedBookingModel>();
                        foreach (var data in receivedBooking) {
                            Console.WriteLine($"{data.Id}, {data.Distance}");
                            var item = new ReceivedBookingModel {};
                            item.IdBooking = data.Id;
                            item.Customer = data.CustomerName;
                            item.Driver = data.DriverName;
                            item.SrcAddress = data.SrcAddress;
                            item.SrcLong =  data.srcLong;
                            item.SrcLat = data.srcLat;
                            item.DesAddress = data.DesAddress;
                            item.DesLong = data.desLong;
                            item.DesLat = data.desLat;
                            item.Distance = data.Distance;
                            item.Total = data.Total;
                            listBooking.Add(item); 
                        }
                        return View("Index", listBooking);

                    } else {
                        return View("Error");
                    }
                await Task.Delay(10000); 
            } catch (Exception e) {
                return View("Error");
            }
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}