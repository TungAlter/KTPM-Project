namespace GrabServer.EventProcess.BookingEvent
{
    public interface IBookingEvent
    {
        void BookingProcessEvent(string msg);
    }
}
