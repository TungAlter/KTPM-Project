using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace CallCenter
{
    public class BLL : PageModel
    {
        private readonly ILogger<BLL> _logger;

        public BLL(ILogger<BLL> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
        }
    }
}