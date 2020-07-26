import socket
sz = 0
#Populated using database
dns_dict = {}
# { "1.1.1.1/28": "India/MP/Indore/6969" , "1.1.1.35/28": "India/MP/Bhopal/6958" , "2.1.1.1/28": "India/Raj/Jaipur/5357" }

def getRealAddress(subnet):
	if subnet in dns_dict:
		return dns_dict[subnet]
	else:
		print "Such a subnet doesn't exist"
		return "-1"

class Trie: 
      
    # Trie data structure class 
    def __init__(self): 
        self.root = self.getNode() 
  
    def getNode(self): 
      
        return TrieNode() 
  
    def _charToIndex(self,ch): 
          
          
        return ord(ch)-ord('a') 
  
  
    def insert(self,key): 
          
        pCrawl = self.root 
        length = len(key) 
        for level in range(length): 
            index = self._charToIndex(key[level]) 
  
            # if current character is not present 
            if not pCrawl.children[index]: 
                pCrawl.children[index] = self.getNode() 
            pCrawl = pCrawl.children[index] 
  
        # mark last node as leaf 
        pCrawl.isEndOfWord = True
  
    def search(self, key): 
          

        pCrawl = self.root 
        length = len(key) 
        for level in range(length): 
            index = self._charToIndex(key[level]) 
            if not pCrawl.children[index]: 
                return False
            pCrawl = pCrawl.children[index] 
  
        return pCrawl != None and pCrawl.isEndOfWord 



def add(subnet , realAddress):
	dns_dict[subnet] = realAddress

def delete(subnet):
    if subnet in dns_dict:
        del dns_dict[subnet]

def update(subnet , realAddress):
    dns_dict[subnet] = realAddress

def set_dns_structure(id , size):
    #set size and type here
def populate_dns(id , url):
    return

def receive_connections():
    # get the hostname
    host = socket.gethostname()
    port = 5000  # initiate port no above 1024

    server_socket = socket.socket()  # get instance
    # look closely. The bind() function takes tuple as argument
    server_socket.bind((host, port))  # bind host address and port together

    # configure how many client the server can listen simultaneously
    server_socket.listen(2)
    conn, address = server_socket.accept()  # accept new connection
    print("Connection from: " + str(address))
    while True:
        data = conn.recv(1024).decode()
        if not data:
            # if data is not received break
            break
        print("from connected user: " + str(data))
        if str(data) not in dns_dict:
        	data = "No entry for subnet"
        else:
        	data = dns_dict[str(data)]
        conn.send(data.encode())  # send data to the client

    conn.close()  # close the connection


#recieve_connections()