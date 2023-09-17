using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CallCenter_MVC.DTOs
{
    public class ReceivedBookingDTO
    {
        public int Id { get; set; } = 0;
        public string CustomerName { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string DriverName { get; set; } = string.Empty;
        public string SrcAddress { get; set; } = string.Empty;
        public string DesAddress { get; set; } = string.Empty;
        public double srcLong { get; set; } 
        public double srcLat { get; set; }
        public double desLong { get; set; }
        public double desLat { get; set; }
        public double Distance { get; set; }
        public int Total { get; set; } = 0;
    }
}
