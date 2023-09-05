using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.DTOs.Booking
{
    public class ReadReceivedBookingDTO
    {
        public string CustomerName { get; set; } = string.Empty;
        public string Phone { get; set; }
        public string DriverName { get; set; }
        public string SrcAddress { get; set; }
        public string DesAddress { get; set; }
        public double srcLong { get; set; }
        public double srcLat { get; set; }
        public double desLong { get; set; }
        public double desLat { get; set; }
        public double Distance { get; set; }
        public int Total { get; set; }
        
    }
}
