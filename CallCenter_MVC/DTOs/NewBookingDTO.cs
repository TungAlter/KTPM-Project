﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CallCenter_MVC.DTOs
{
    public class NewBookingDTO
    {
        public int Id { get; set; } = 0;
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string AddrFrom { get; set; } = string.Empty;
        public string AddrTo { get; set; } = string.Empty;
        public double SrcLong { get; set; } = double.MaxValue;
        public double SrcLat { get; set; } = double.MaxValue;
        public double DesLong { get; set; } = double.MaxValue;
        public double DesLat { get; set; } = double.MaxValue;
        public double Distance { get; set; } = 0;
    }
}
