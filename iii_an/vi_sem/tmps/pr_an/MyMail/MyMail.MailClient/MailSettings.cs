using MyMail.MailClient.Entities;

namespace MailClient
{
    public class MailSettings
    {
        public Server server { get; private set; }
        public User user { get; private set; }

        private static MailSettings _instance;

        private MailSettings()
        {
        }

        public void SetServer(Server server)
        {
            this.server = server;
        }

        public void SetUser(User user)
        {
            this.user = user;
        }

        public static MailSettings Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new MailSettings();
                }
                return _instance;
            }
        }
    }
}
