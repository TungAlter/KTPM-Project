using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.Models
{
    public class Driver : ModelBase
    {
        public int Id { get; set; }
        //public int DriverRank { get; set; }
        public string FullName { get; set; } = string.Empty;
        public DateTime DateBirth { get; set; }
        public string Email { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        
        public string Gender { get; set; } = string.Empty;
        //public string Avatar { get; set; } = string.Empty;
        public double Rating { get; set; }
        //public string WorkStatus { get; set; } = string.Empty;
    }
}
