using GrabServerCore.DTOs;
using System.Text.Json;

namespace GrabServer.EventProcess.BookingEvent
{
    public class BookingEvent : IBookingEvent
    {

        private readonly IServiceScopeFactory _scpFactory;

        public BookingEvent(IServiceScopeFactory scpFactory)
        {
            _scpFactory = scpFactory;

        }
        public void BookingProcessEvent(string msg)
        {
            var event_type = DetermineEventType(msg);
            switch (event_type)
            {
                case eventType.GET_RECENT:
                    DateTime dateTime = DateTime.UtcNow;
                    Console.WriteLine("We have processed PlatformPubished Event at " + dateTime.ToString());
                    AddPlatform(msg);
                    break;
                default:
                    break;
            }
        }

        private eventType DetermineEventType(string notificationMsg)
        {
            Console.WriteLine("---> Determine Event Type");
            var event_type = JsonSerializer.Deserialize<GenericEvent>(notificationMsg);
            switch (event_type?.Event)
            {
                case "Platform_Published":
                    Console.WriteLine("Platform Published Event Detected");
                    return eventType.GET_RECENT;
                default:
                    Console.WriteLine("Could not determine event type");
                    return eventType.Undetermined;
            }
        }

        private void AddPlatform(string platformPublishMsg)
        {
            //Console.WriteLine("Đã nhận đc Event !!\n");
            //using (var scope = _scpFactory.CreateScope())
            //{
            //    var repo = scope.ServiceProvider.GetRequiredService<IBookingService>();
            //    var platformPublishedDTO = JsonSerializer.Deserialize<Platform>(platformPublishMsg);
            //    try
            //    {
            //        List<RecentBookingDTO> l = repo.GetNewBookingAsync();
            //        foreach (var item in l)
            //        {
            //            Console.WriteLine("Item là: " + item.Id.ToString());
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        Console.WriteLine($"Could not add Platform Event: {ex.Message}");
            //        throw;
            //    }
            //}
        }
        enum eventType
        {
            GET_RECENT,
            GET_NEW,
            GET_RECEIVED,
            POST_NEW,
            DELETE,
            PUT_LOCATION,
            PUT_FIND_DRIVER,
            PUT_COMPLETED,
            PUT_CACULATE_TOTAL,
            Undetermined
        }
    }
}
