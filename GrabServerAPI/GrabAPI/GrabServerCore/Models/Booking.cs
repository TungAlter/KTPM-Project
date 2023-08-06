using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.Models
{
    public class Booking :ModelBase
    {
        public int IdBooking { get; set; }
        public int IdCustomer { get; set; }
        public int IdDriver { get; set; }
        public DateTime DateBooking { get; set; }
        public string Status { get; set; } = string.Empty;
        public double SrcLong { get; set; }
        public double SrcLat { get; set; }
        public string SrcAddress { get; set; } = string.Empty;
        public double DesLong { get; set; }
        public double DesLat { get; set; }
        public string DesAddress { get; set; } = string.Empty;
        public string Notes { get; set; } = string.Empty;
        public int Total { get; set; }
        

    }
}
