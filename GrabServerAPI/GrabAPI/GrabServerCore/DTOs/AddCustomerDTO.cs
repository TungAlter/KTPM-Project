using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GrabServerCore.Models;

namespace GrabServerCore.DTOs
{
    public class AddCustomerDTO : ModelBase
    {
        public string Fullname { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public DateOnly DateBirth { get; set; }
        public string Gender { get; set; } = string.Empty;
        public string Avatar { get; set; } = string.Empty;
    }
}
