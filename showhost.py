import logging
from mitmproxy.http import HTTPFlow

'''
通过mitmproxy显示请求的域名：

mitmdump --set flow_detail=0 --set termlog_verbosity=warn -s showhost.py -p 8000
'''


class HostHeader:
    def responseheaders(self, flow: HTTPFlow) -> None:
        # stream response
        flow.response.stream = True

    def request(self, flow: HTTPFlow) -> None:
        target = flow.request.host_header
        logging.warn(f"{target}")


addons = [HostHeader()]
