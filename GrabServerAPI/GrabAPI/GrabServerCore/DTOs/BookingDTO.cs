using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.DTOs {
    public class BookingDTO {
        public int IdBooking { get; set;}
        public int IdCustomer { get; set;}
        public string SrcAddress { get; set;}
        public string DesAddress { get; set;}
        
    }
}