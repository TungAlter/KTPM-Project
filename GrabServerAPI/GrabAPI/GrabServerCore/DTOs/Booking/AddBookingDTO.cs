using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.DTOs.Booking
{
    public class AddBookingDTO
    {
        public int IdCustomer { get; set; }
        public DateTime DateBooking { get; set; }
        public double SrcLong { get; set; } = double.MaxValue;
        public double SrcLat { get; set; } = double.MaxValue;
        public string SrcAddress { get; set; } = string.Empty;
        public double DesLong { get; set; } = double.MaxValue;
        public double DesLat { get; set; } = double.MaxValue;
        public string DesAddress { get; set; } = string.Empty;
        public double Distance { get; set; } = 0;
        public string Notes { get; set; } = string.Empty;
        public int Total { get; set; }
    }
}
