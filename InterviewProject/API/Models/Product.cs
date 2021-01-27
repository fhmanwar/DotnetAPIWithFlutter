using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    [Table("Tbl_Product")]
    public class Product
    {
        [Key]
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        [ForeignKey("Category")]
        public int ProductCategory { get; set; }

        public int Stock { get; set; }
        public int Price { get; set; }
        public string Unit { get; set; }


        public ProductCategory Category { get; set; }
    }
}
