using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    [Table("Tbl_Transaction")]
    public class Transaction
    {
        [Key]
        public int TransactionId { get; set; }
        public DateTimeOffset OrderDate { get; set; }
        public int Total { get; set; }
    }
}
