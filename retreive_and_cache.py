from collections import OrderedDict 
CACHE_SIZE = 10
cur_size = 0
timestamp = 0


class Node:
    def __init__(self, dataval=None):
        self.dataval = dataval
        self.nextval = None

class SLinkedList:
    def __init__(self):
        self.headVal = None

    def insert(self,newdata):
        NewNode = Node(newdata)
        NewNode.nextval = self.headval

#LRU Cache implemented
#Cache eviction done on the basis of timestamp which denotes how recent an item was used  
class LRUCache: 
  
    # initialising capacity 
    def __init__(self, capacity): 
        #self.cache = OrderedDict() 
        self.capacity = capacity 
  
    # we return the value of the key 
    # that is queried in O(1) and return -1 if we 
    # don't find the key in out dict / cache. 

    def get(self, key): 
        if key not in self.cache: 
            return "-1"
        else: 
            self.cache.move_to_end(key) 
            return self.cache[key] 
  
    # first, we add / update the key by conventional methods. 
    # And also move the key to the end to show that it was recently used. 

    def put(self, key, value): 
        self.cache[key] = value 
        self.cache.move_to_end(key) 
        if len(self.cache) > self.capacity: 
            self.cache.popitem(last = False) 
  

cache = LRUCache(CACHE_SIZE)  

def retrieve(subnet):
	elem = cache.get(subnet)
	if elem == "-1":
		#get from virtual_dns
		connect_to_dns(subnet)
	else:
		return elem


def get_cache_state():
	return cache.cache

def getSize():
    return cache.capacity

def setSize(sz):
    cache.capacity = sz

def least_recently_used():
    return cache[0]

def most_recently_used():
    return cache[len(cache) - 1]

def connect_to_dns(subnet):
    host = socket.gethostname()  # as both code is running on same pc
    port = 5000  # socket server port number

    client_socket = socket.socket()  # instantiate
    client_socket.connect((host, port))  # connect to the server

    message = subnet

    while message.lower().strip() != 'bye':
        client_socket.send(message.encode())  # send message
        data = client_socket.recv(1024).decode()  # receive response
        print('Received from server: ' + str(data))  # show in terminal
        cache.put(subnet,str(data))
        #explicitly brek after recieving subnet address
        break

    client_socket.close()  # close the connection
