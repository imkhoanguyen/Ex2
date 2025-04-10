using System.ComponentModel.DataAnnotations;

namespace Ex2.Entities
{
    public class Product
    {
        [Key]
        public int ProductId { get; set; }
        public required string ProductName { get; set; }
        public required string Category { get; set; }
        public decimal Price { get; set; }
        public int Stock { get; set; }

    }
}
