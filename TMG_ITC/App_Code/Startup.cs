using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(TMG_ITC.Startup))]
namespace TMG_ITC
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
