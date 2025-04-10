namespace Ex2.Dtos
{
    public class OrderResponse
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public string? CustomerName { get; set; }
        public decimal? TotalAmount { get; set; }
        public int? TotalQuantity { get; set; }
        public DateTime? ShipmentDate { get; set; }
        public string? DeliveryStatus { get; set; }
        public string? OrderStatus { get; set; } 
    }
}
