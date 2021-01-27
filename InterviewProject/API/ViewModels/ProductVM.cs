using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.ViewModels
{
    public class CategoryProductVM
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public class ProductVM
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public int Stock { get; set; }
        public int Price { get; set; }
        public string Unit { get; set; }
    }
}
