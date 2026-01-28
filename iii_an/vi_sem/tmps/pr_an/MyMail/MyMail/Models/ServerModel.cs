using System.ComponentModel.DataAnnotations;

namespace MyMail.Models
{
	public class ServerModel
	{
		[Display(Name = "Server Name: ")]
		public string ServerName { get; set; } = string.Empty;

		[Display(Name = "SMTP Port: ")]
		public int SmtpPort { get; set; } = 587;

		[Display(Name = "POP3 Port: ")]
		public int Pop3Port { get; set; } = 995;

		[Display(Name = "IMAP Port: ")]
		public int ImapPort { get; set; } = 993;

	}
}
