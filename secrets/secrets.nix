let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK57s5sR1Kfqr6K6dCMJRo2NU0F9OeLrF//sOrlDSd2R";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJzLKmVZwfvUr3dtJZJW+sADPY75gXACxraes7gf1ia";
  user3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHQ3V/Ikc3SPoP1ypRvGlcQoEbRlfqdIhHg+vMWFGRj";
  user4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGknpJ0yi8/WHosLWyxqdb4BVf3aXKbsM6WUWHuw8hdP";
  user5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ50zzX7xAN0CsnjMXfSPt6dpnSVq+aYFSZl/VYvIeEp";
  user6 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwTdMZ1i3vAkalxbcXtxKgyFOsr5JCFQxuu45koOvfa";

  users = [ user1 user2 user3 user4 user5 user6 ];

in
{
  "secret1.age".publicKeys = users;
  "ghtoken.age".publicKeys = users;
  "awstoken.age".publicKeys = users;
  "openaitoken.age".publicKeys = users;
  "hfacetoken.age".publicKeys = users;
  "gcptoken.age".publicKeys = users;
}
