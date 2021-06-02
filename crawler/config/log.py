import logging

logging.basicConfig(format='[%(asctime)s] %(message)s', datefmt='%d-%b-%y %H:%M:%S',
                    level=logging.NOTSET)

logger = logging.getLogger('leggo-twitter-dados')
