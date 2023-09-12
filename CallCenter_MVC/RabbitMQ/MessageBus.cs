using System.Text;
using System.Text.Json;
using RabbitMQ.Client;

namespace CallCenter_MVC.RabbitMQ
{
    public class MessageBus : IMessageBus
    {
        private readonly IConfiguration _config;
        private readonly IConnection _connection;
        private readonly IModel _channel;

        public MessageBus(IConfiguration config)
        {
            _config = config;
            var factory = new ConnectionFactory()
            {
                HostName = _config["RabbitMQHost"],
                Port = int.Parse(_config["RabbitMQPort"])
            };
            try
            {
                _connection = factory.CreateConnection();
                _channel = _connection.CreateModel();
                _channel.ExchangeDeclare(exchange: "trigger", type: ExchangeType.Fanout);
                _connection.ConnectionShutdown += RabbitMQConnectionShutdown;
                Console.WriteLine("Connect to MessageBus");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"--> Could not connect to RabbitMQ: {ex.Message}");
            }
        }
        void GetNewBooking()
        {
            string p = "GET_NEW";
            var msg = JsonSerializer.Serialize(p);
            if (_connection.IsOpen)
            {
                Console.WriteLine("--> RabbitMQ Connection Open, Sending Message.........");
                SendingMessage(msg);
            }
            else
            {
                Console.WriteLine("--> RabbitMQ Connection Closed, Reconnecting.........");
            }
        }
        private void SendingMessage(string Message)
        {
            var body = Encoding.UTF8.GetBytes(Message);
            _channel.BasicPublish(exchange: "trigger",
                                    routingKey: "",
                                    basicProperties: null,
                                    body: body);
            Console.WriteLine($"We have sent {Message} to RabbitMQ");
        }

        public void Depose()
        {
            Console.WriteLine("MessageBus Disposed");
            if (_channel.IsOpen)
            {
                _channel.Close();
                _connection.Close();
            }
        }
        private void RabbitMQConnectionShutdown(object sender, ShutdownEventArgs e)
        {
            Console.WriteLine("--> RabbitMQ connection shutdown");
        }


    }
}
