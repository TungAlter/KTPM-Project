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
    public class HomeS2Controller : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly string _apiUrl = "http://localhost:5236/api/Booking/new";

        public HomeS2Controller(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            try
            {
                var httpClient = _httpClientFactory.CreateClient();
                var response = await httpClient.GetAsync(_apiUrl);
                Console.WriteLine($"State Code: {response.StatusCode}");
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    var content = await response.Content.ReadAsStringAsync();

                    var newBooking = JsonConvert.DeserializeObject<IEnumerable<NewBookingDTO>>(content);

                    var listBooking = new List<BookingModel>();
                    foreach (var data in newBooking)
                    {
                        Console.WriteLine($"{data.Id}, {data.Distance}");
                        var item = new BookingModel { };
                        
                        item.IdBooking = data.Id;
                        item.Customer = data.FullName;
                        item.SrcAddress = data.AddrFrom;
                        item.SrcLong = data.SrcLong;
                        item.SrcLat = data.SrcLat;
                        item.DesAddress = data.AddrTo;
                        item.DesLong = data.DesLong;
                        item.DesLat = data.DesLat;
                        item.Distance = item.Distance;
                        listBooking.Add(item);
                    }
                    return View("Index", listBooking);

                }
                else
                {
                    return View("Error");
                }
                await Task.Delay(10000);
            }
            catch (Exception e)
            {
                return View("Error");
            }
        }

        [HttpDelete]
        [Route("/HomeS2/Delete/{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            
            Console.WriteLine(id);
            try
            {
                var urlDelete = $"http://localhost:5236/api/Booking?IdBooking={id}";
                var httpClient = _httpClientFactory.CreateClient();
                Console.WriteLine(urlDelete);
                using (httpClient)
                {
                    var response = await httpClient.DeleteAsync(urlDelete);
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        return View("Index");
                    }
                    else
                    {
                        return View("Error");
                    }
                }

            }
            catch (Exception e)
            {
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