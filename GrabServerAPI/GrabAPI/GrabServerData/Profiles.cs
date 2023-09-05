using AutoMapper;
using GrabServerCore.DTOs.Booking;
using GrabServerCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerData
{
    public class Profiles : Profile
    {
        public Profiles()
        {
            CreateMap<Booking, RecentBookingDTO>();
        }
    }
}
