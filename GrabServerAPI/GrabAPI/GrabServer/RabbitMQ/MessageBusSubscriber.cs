using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using GrabServer.EventProcess;
using System.Text;


namespace GrabServer.RabbitMQ
{
    public class MessageBusSubscriber : BackgroundService
    {
        private readonly IConfiguration _config;
        private readonly IEventProcess _eventProcessing;
        private IConnection _connection;
        private IModel _channel;
        private string _queueName;

        public MessageBusSubscriber(IConfiguration config, IEventProcess eventProcessing)
        {
            _config = config;
            _eventProcessing = eventProcessing;
            InitializeRabbitMQ();
        }

        private void InitializeRabbitMQ()
        {
            var factory = new ConnectionFactory()
            {
                HostName = _config["RabbitMQHost"],
                Port = int.Parse(_config["RabbitMQPort"])
            };
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.ExchangeDeclare(exchange: "trigger", type: ExchangeType.Fanout);
            _queueName = _channel.QueueDeclare().QueueName;
            _channel.QueueBind(queue: _queueName,
                                exchange: "trigger",
                                routingKey: "");
            Console.WriteLine("---> Listening on the MessageBus");
            _connection.ConnectionShutdown += RabbitMQ_ConnectionShutdown;
        }
        protected override Task ExecuteAsync(CancellationToken stoppingToken)
        {
            stoppingToken.ThrowIfCancellationRequested();

            var consumer = new EventingBasicConsumer(_channel);
            consumer.Received += (ModuleHandle, ea) =>
            {
                Console.WriteLine("Event Received ");
                var body = ea.Body;
                var notification = Encoding.UTF8.GetString(body.ToArray());
                _eventProcessing.ProcessEvent(notification);

            };
            _channel.BasicConsume(queue: _queueName, consumer: consumer, autoAck: true);
            return Task.CompletedTask;
        }

        private void RabbitMQ_ConnectionShutdown(object sender, ShutdownEventArgs e)
        {
            Console.WriteLine("Connection Shutdown");
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
    }
}
