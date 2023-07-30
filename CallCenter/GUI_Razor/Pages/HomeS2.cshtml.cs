using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace GUI_Razor.Pages
{
    public class HomeS2 : PageModel
    {
        private readonly ILogger<HomeS2> _logger;

        public HomeS2(ILogger<HomeS2> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
        }
    }
}