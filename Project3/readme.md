<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This terraform script will auto create a pi-hole DNS server in AWS. It will create all the necessary infrastructure e.g VPC, route table, security group etc. Before launching the ec2 instance the server will run on. All the setting are pre-done and can be chagned in the user_data section.

Make sure to change the security IP ranges to yours. As well the key pair name to your key pair. If you don't require to SSH into the instance you can remove this line from instance resource.
![alt text](Img/DNS-Sink.png)
<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Terraform](https://www.terraform.io/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

1. [Terrafom CLI](https://www.terraform.io/downloads)
2. [AWS Account](https://aws.amazon.com/)
3. [You will need to make a key pair if you wish to SSH into the instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)
  
### Installation

1. Clone the repo *Project 3*
2. Update the following
   ```sh
   AWS cli credentials in provider.tf
   Key_name in Main.tf
   SG cidr_blocks in Main.tf   
   ```
3. Run Terraform apply

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- ROADMAP -->
## Roadmap

- [x] One line deplayment
- [x] Preconfigure settings
- [ ] Auto genarate SSH Key
- [ ] Bake setting into Golden Image
- [ ] Enable SSL for private dns on Android

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Project Link: [https://github.com/HammerAndRay/Project-1-TF/tree/master/Project3)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Choose an Open Source License](https://choosealicense.com)
* [Normal Pi-Hole AWS setup](https://medium.com/@dion315/setting-up-a-free-pi-hole-on-aws-c24511888973#:~:text=A%20Pi%2DHole%20is%20a,way%20it%20works%20is%20simple.)
* [README Template](https://github.com/othneildrew/Best-README-Template)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
