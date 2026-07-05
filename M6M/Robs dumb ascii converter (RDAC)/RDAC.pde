//settings------------

boolean useCustomColor = true; //leave false if you want the images original colors;
color inputColor = color(11, 16, 51);   //color of the characters, only does something if useCustomColors is true
// teal: color(0, 30, 36);
// red: color(57, 10, 12);
// purple: color(35, 13, 50);
// blue: color(11, 16, 51);
color backgroundColor = color(0, 255, 19);   //color of the background
int characterLimit = 7;   //how many different characters are there
int frameLimit = 400;   //how many different frames are there (set to 1 if you want to convert a single frame, still name the input "0.png")
int padding = 0;   //add padding around all characters (only affects bottom/ right edges, its kinda ass)

//--------------------

//global vars
PImage[] characters = new PImage[characterLimit];
int characterBounds  = 0;
PImage[] frames = new PImage[frameLimit];
int maxWidth = 0;
int maxHeight = 0;
float avg;

void settings()
{
  //load all images, check if they exceed and then update the image bounds
  for(int i = 0; i < frameLimit; i++)
  {
    frames[i] = loadImage("input/" + i + ".png");
    maxWidth = max(maxWidth, frames[i].width);
    maxHeight = max(maxHeight, frames[i].height);
  }
  
  //load all characters, check if they exceed and then update the character bounds
  for(int i = 0; i < characterLimit; i++)
  {
    characters[i] = loadImage("characters/" + i + ".png");
    characterBounds = max(characterBounds, characters[i].width,characters[i].height);
  }
  
  //add padding
  characterBounds += padding;
  
  //set image dimensions
  size(maxWidth, maxHeight);
}

void setup()
{
  //change the character images according to the inputColor (only in the software, real images are not affected)
  if(useCustomColor)
  {
    colorMode(HSB, 360, 100, 100, 255);
    
    for(int i = 0; i < characters.length; i++)
    {
      for(int y = 0; y < characters[i].height; y++)
      {
        for(int x = 0; x < characters[i].width; x++)
        {
          characters[i].set(x, y, color(hue(inputColor), saturation(inputColor), brightness(inputColor), alpha(characters[i].get(x,y))));
        }
      }
    }
    colorMode(RGB,255,255,255,255);
  }
  
  //every frame, set background, convert picture, save, repeat
  for(int i = 0; i < frameLimit; i++)
  {
    background(backgroundColor);
    convert(frames[i]);
    saveFrame("output/" + i + ".png");
  }
}

void convert(PImage input)
{  
  //for every x,y character
  for(int y = 0; y <= input.height-characterBounds; y += characterBounds)
  {
    for(int x = 0; x <= input.width-characterBounds; x += characterBounds)
    {
      avg = 0;
      
      //for every pixel within a characters region
      for(int yd = 0; yd < characterBounds; yd++)
      {
        for(int xd = 0; xd < characterBounds; xd++)
        {
          avg += brightness(input.get(x+xd,y+yd));
        }
      }
      
      //get the average brightness
      avg = avg / sq(characterBounds);
      
      //set the character according to the avgerage brightness
      image(characters[floor(avg*characterLimit/256.0)],x,y);
    }
  }
  return;
}
