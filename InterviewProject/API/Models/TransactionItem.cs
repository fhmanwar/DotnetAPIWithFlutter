using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    [Table("Tbl_TransactionItem")]
    public class TransactionItem
    {
        [Key]
        public int TransactionItemId { get; set; }
        [ForeignKey("Transaction")]
        public int TransactionId { get; set; }
        [ForeignKey("Product")]
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public int SubTotal { get; set; }

        public Transaction Transaction { get; set; }
        public Product Product { get; set; }
    }
}
