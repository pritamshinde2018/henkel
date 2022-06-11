public class ShipmentNotificationWrapper {
    public class Response {
		public Integer shipped_count;
		public Integer delivered_count;
		public List<Product_shipped> product_shipped;
		public List<product_delivered> product_delivered;
	}

	public Response response;

	public class Product_shipped {
		public String product_name;
		public String product_sku;
        public String IBInvoiceUrl;
	}
    
public class product_delivered {
		public String product_name;
		public String product_sku;
        public String IBInvoiceUrl;
	}

}