# 1. Mo hinh

```sh
                                        
                            +-----------+-----------+                 +-------------------+
                            |       [VPNServer]     |                 |    [VPNClient]    |
                            |       10.10.10.11     |  10.10.10.0/24  |                   |
                            |        10.0.0.51      +-----------------+     10.10.10.51   |
                            |                       | ens38           |                   |
                            |                       |                 |                   |
                            |                       |                 |                   |
                            +-----------+-----------+                 +-------------------+
                                        | ens34
                                        |
                                        | 
                        +----------------------------+
                        |                            |                   
                        |                            |           
            +-----------+-----------+    +-----------+-----------+
            |        [host01]       |    |        [host02]       | 
            |                       |    |                       |   
            |        10.0.0.52      |    |        10.0.0.53      |    
            |                       |    |                       |    
            |                       |    |                       | 
            |                       |    |                       |    
            +-----------+-----------+    +-----------------------+    
  ```
  
  
  