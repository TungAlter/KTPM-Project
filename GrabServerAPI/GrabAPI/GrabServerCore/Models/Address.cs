using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GrabServerCore.Models
{
    public class Address
    {
        public string address { get; set; } = string.Empty;
        public string ward { get; set; } = string.Empty;
        public string district { get; set; } = string.Empty;
        public string province { get; set; } = string.Empty;

    }
}
