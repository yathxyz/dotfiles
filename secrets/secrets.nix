let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK57s5sR1Kfqr6K6dCMJRo2NU0F9OeLrF//sOrlDSd2R";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJzLKmVZwfvUr3dtJZJW+sADPY75gXACxraes7gf1ia";
  user3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHQ3V/Ikc3SPoP1ypRvGlcQoEbRlfqdIhHg+vMWFGRj";
  user4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGknpJ0yi8/WHosLWyxqdb4BVf3aXKbsM6WUWHuw8hdP";
  user5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ50zzX7xAN0CsnjMXfSPt6dpnSVq+aYFSZl/VYvIeEp";
  user6 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwTdMZ1i3vAkalxbcXtxKgyFOsr5JCFQxuu45koOvfa";
  user7 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDN3bYPtZzGrLtd+dbMB/CEjquk97IkNH1pCb9mpU1J7XhdMwWWp4UQR8sCnQHFFKKKgeOcCEEcHaKokVEdUK+ixG4rD2ExtSWXJvvd5pFEQ0oTG4RdP0NIJXTwvH+7AGy2iMcObdMJ0wk8U8hFnjUyYrTIeOrTQ/lspsdl4L4J7MgvysXCVXdR2uwDVceyTS7ZhKuWusOvH5GYxzyAWo4GnqF1qy1bJcTyWtq8aZDpL+55N0+bayUZJ8/DrbH8zJJPemp5y+fz386LdEWwrWYMhbPkI13EDadv4QK/ey96p6DbjOCITEeO79OXWXyExDGk1i0yPdBTQQl+SMf4aFx0WMbK7JrvA7R5NohSPvX+ksq/FrrCshC83KELVTJUzJ2MqDL5VOqYMjwTfLGWN08YwCDMExFjKC6oylfKlwligk1HdN/6Hpgre9efC9CK/bC3g/cEahUjow5HEhDESialGuaAs9LjcWCpocVjrkL2A+WnCjp5QVI+xq2+vLcsRL8= yanni@thinkpad";

  users = [ user1 user2 user3 user4 user5 user6 user7 ];

in
{
  "secret1.age".publicKeys = users;
  "ghtoken.age".publicKeys = users;
  "awstoken.age".publicKeys = users;
  "openaitoken.age".publicKeys = users;
  "hfacetoken.age".publicKeys = users;
  "gcptoken.age".publicKeys = users;
  "cloudflaretoken.age".publicKeys = users;
}

