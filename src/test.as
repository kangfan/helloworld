package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import common.counters.Steady;
	import common.displayObjects.RadialDot;
	import common.initializers.ImageClass;
	import common.initializers.ScaleImageInit;
	import twoD.actions.DeathZone;
	import twoD.actions.Move;
	import twoD.actions.RandomDrift;
	import twoD.emitters.Emitter2D;
	import twoD.initializers.Position;
	import twoD.initializers.Velocity;
	import twoD.renderers.DisplayObjectRenderer;
	import twoD.zones.LineZone;
	import twoD.zones.PointZone;
	import twoD.zones.RectangleZone;
	
	/**
	 * @description 
	 * @author 康自军
	 * @time　2014-10-24
	 */
	[ SWF( backgroundColor="#000000", frameRate="30", width="822", height="545" ) ]
	public class test extends Sprite
	{
		private var _loader:Loader;
		
		private var _avatar:MovieClip;
		
		public function test()
		{
			initView();
			this.addEventListener( Event.ENTER_FRAME, onFrameHandler );
		}
		
		protected function onFrameHandler(event:Event):void
		{
			if( _avatar == null )
				return;
		}
		
		private function initView():void
		{
			var url:URLRequest = new URLRequest( "../bg.jpg" );
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			_loader.load( url );
		}
		
		protected function onLoadComplete( event:Event ):void
		{
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
			var bg:Bitmap = event.target.content as Bitmap;
			this.addChild( bg );
			initParticle();
			initAvatar();
		}
		
		private function initAvatar():void
		{
			var url:URLRequest = new URLRequest( "../walk.swf" );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onAvatarComplete );
			_loader.load( url );
		}
		
		private function onAvatarComplete( evt:Event ):void
		{
			_avatar = evt.target.content as MovieClip;
			this.addChild( _avatar );
			
			var clss:Class = _avatar.loaderInfo.applicationDomain.getDefinition( "walk_d0_0" ) as Class;
			var bmpd:BitmapData = new clss( 0, 0 ) as BitmapData;
			var bmp:Bitmap = new Bitmap( bmpd );
			bmp.x = 400;
			bmp.y = 350;
			this.addChild( bmp );
		}
		
		private function initParticle():void
		{
			var emitter:Emitter2D = new Emitter2D();
			
			emitter.counter = new Steady( 100 );
			
			emitter.addInitializer( new ImageClass( RadialDot, [ 2 ] ) );
			emitter.addInitializer( new Position( new LineZone( new Point( 20, -5 ), new Point( 782, -5 ) ) ) );
			emitter.addInitializer( new Velocity( new PointZone( new Point( 0, 65 ) ) ) );
			emitter.addInitializer( new ScaleImageInit( 0.75, 2 ) );
			
			emitter.addAction( new Move() );
			emitter.addAction( new DeathZone( new RectangleZone( -10, -10, 802, 525 ), true ) );
			emitter.addAction( new RandomDrift( 15, 15 ) );
			
			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			addChild( renderer );
			renderer.addEmitter( emitter );
			
			emitter.start();
			emitter.runAhead( 10 );
		}
	}
}