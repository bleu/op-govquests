import Image from "next/image";
import Link from "next/link";

const socials = [
  {
    name: "notion",
    link: "https://bleu.builders/",
    icon: "/footerIcons/notion.svg",
  },
  {
    name: "github",
    link: "https://github.com/bleu",
    icon: "/footerIcons/github.svg",
  },
  {
    name: "x",
    link: "https://x.com/bleubuilders",
    icon: "/footerIcons/x.svg",
  },
];

const Footer = () => {
  return (
    <footer className="px-16 py-5 flex justify-between items-center w-full bg-background/70 relative z-10">
      <div className="flex items-center gap-2 h-8">
        {socials.map((social) => (
          <Link
            href={social.link}
            className="object-contain h-full"
            target="_blank"
            key={social.name}
          >
            <Image
              src={social.icon}
              width={100}
              height={100}
              alt={social.name}
              className="w-fit h-full object-scale-down"
            />
          </Link>
        ))}
      </div>
      <div className="flex items-center gap-2 text-sm">
        built by
        <Link href="https://bleu.builders/" target="_blank">
          <Image
            src="/bleuLogo.png"
            alt="bleuLogo"
            width={200}
            height={200}
            className="h-4 object-scale-down w-fit"
          />
        </Link>
      </div>
    </footer>
  );
};

export default Footer;
