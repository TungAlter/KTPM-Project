using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CallCenter_MVC.Models
{
    public class BookingModel
    {
        public int IdBooking { get; set; }
        public string Customer { get; set; } = string.Empty;
         public string SrcAddress { get; set; } = string.Empty;
        public double SrcLong { get; set; } = double.MaxValue;
        public double SrcLat { get; set; } = double.MaxValue;
        public string DesAddress { get; set; } = string.Empty;
        public double DesLong { get; set; } = double.MaxValue;
        public double DesLat { get; set; } = double.MaxValue;
        public double Distance { get; set; } = 0;   
    }
}