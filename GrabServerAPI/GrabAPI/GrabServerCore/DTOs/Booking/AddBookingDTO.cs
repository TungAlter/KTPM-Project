﻿using GrabServerCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.DTOs.Booking
{
    public class AddBookingDTO
    {
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public Address addrFrom { get; set; }
        public Address addrTo { get; set; }

    }
}
