package  {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent;
    import flash.system.ImageDecodingPolicy; 
    import flash.system.LoaderContext; 
	import flash.filters.*;

					
	public class Player extends MovieClip{

        private var loaderContext:LoaderContext;
		
		public var imageLoader:Loader = new Loader();
		public var theImage:DisplayObject;
		public var tickLoader:Loader = new Loader();
		public var theTick:DisplayObject;
		public var phLoader:Loader = new Loader();
		public var thePh:DisplayObject;
		
		public var pname:String;
		public var angle:int;
		public var tick:Boolean = false;
		public var size:Number;
		public var level:int;
		public var index:int;
		public var originalSize:Number;

		public function Player(details:Object = null) {
			if(details){
				if(details.scale){					
					this.size = details.scale;
					scale(details.scale);
					this.originalSize = details.scale;
				}
				if(details.x) this.x = details.x;
				if(details.y) this.y = details.y;
				if(details.level) this.level = details.level;
				if(details.index) this.index = details.index;
				if(details.tick) this.tick = details.tick;
				
				if(details.pname){
					pname = details.pname;
					preLoadPlayerImage();
					preLoadTickandPlaceholder();
				}
			}
		}
		
		private function preLoadPlayerImage():void{			
            var loaderContext:LoaderContext = new LoaderContext(); 
            loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;   
			imageLoader.load(new URLRequest("playerpics/"+this.pname+".png"), loaderContext);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.placeImage);
			imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.prog);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
			
		}
		
		private function preLoadTickandPlaceholder():void{
			//phLoader.load(new URLRequest("pngs/ph.png"));
			//phLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.phReady);
			//phLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
			tickLoader.load(new URLRequest("pngs/tick.png"));
			tickLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.tickReady);
			tickLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
		}

		public function prog(evt:ProgressEvent):void{
			//trace(this.pname+" "+(evt.bytesLoaded/evt.bytesTotal)*100+"%")
		}
		
		public function loadError(err:Event):void{
			trace("Error loading image")
		}
		
		public function set(k,v):void{
			if(k&&v){
				this[k] = v;
			}
		}
		
		public function showImage():void{
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			this.filters = []
			this.alpha = 1
			this.theImage = addChild (imageLoader);
			this.tickMe(this.tick);
		}
		
		public function placeImage(event:Event):void{
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.placeImage);
			
			//this.theImage = this.level==0 ? addChild (imageLoader) : addChild (phLoader);
			this.theImage = addChild (imageLoader);
			
			 if(this.level!=0){
				var cover:DropShadowFilter = new DropShadowFilter();
				cover.distance = 600;
				cover.color = 0xaaaaaa;
				cover.blurX = 10;
				cover.blurY = 10;
				cover.quality = 3;
				cover.inner = true;
				this.filters = [cover];
				this.alpha = 0.75
			 }
			
			this.tickMe(this.tick);

			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverEffect); 
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutEffect); 
			this.addEventListener(MouseEvent.MOUSE_UP, this.select); 
		}
		
		public function tickReady(event:Event):void{
			tickLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.tickReady);
		}
		public function phReady(event:Event):void{
			//phLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.phReady);
		}
		
		public function select(e:Event):void{
			var _root = MovieClip(root);
			if(_root.playerNum!=this.index){
				_root.gotoAndStop("player");
				_root.setupQuestion(this.index);
			}
		}		
		
		public function tickMe(ticked:Boolean=false):void{
			this.tick = ticked
			if(this.tick==true){	
				this.theTick = addChild(tickLoader);
				this.theTick.x=300;
				this.theTick.y=210;
				
			}else{
				if(this.theTick){
					this.theTick = null;
				}
			}
		}

		public function scale(s:Number):void{
			this.scaleX = s
			this.scaleY = s
		}
		
		public function mouseOverEffect(e:Event):void{
			//this.scale(this.size+(this.size/25));  //4% scale
			this.rotationY = this.rotationY + 10
		}		
		
		public function mouseOutEffect(e:Event):void{
			//this.scale(this.size);			
			this.rotationY = this.rotationY - 10
		}
		
		//  ANIMATION CONTROLS - JUST GETS IMAGE TO ORBIT AROUND IN A CIRCLE
		public function startAnimation(a:String = null):void{
			if(a=="orbit") this.addEventListener(Event.ENTER_FRAME, orbit); 
			if(a=="rotate3d") this.addEventListener(Event.ENTER_FRAME, rotate3d); 
		}
		
		public function stopAnimation(a:String = null):void{
			if(a=="orbit") this.removeEventListener(Event.ENTER_FRAME, orbit); 
		}
		
		public function orbit(e:Event):void{
			angle +=1;
			this.x = this.x + .2 * Math.cos(angle * (Math.PI / 180));
			this.y = this.y + .2 * Math.sin(angle * (Math.PI / 180));
		}
		
		public function rotate3d(e:Event):void{
			angle +=1;
			this.rotationY = this.rotationY + 2 //* Math.cos(angle * (Math.PI / 180)); //The Math.cos causes a weird swing effect
		}
		
		
	}
	
}
