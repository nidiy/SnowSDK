package snow.scene3D 
{
	import away3d.materials.ColorMaterial;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import flash.net.URLRequest;
	
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	import away3d.materials.MaterialBase;
	import away3d.textures.TextureProxyBase;
	/**
	 * ...
	 * @author 
	 */
	public class MD53DObject extends ObjectContainer3D 
	{
		protected var _skeleton:Skeleton
	    protected var _animationSet:SkeletonAnimationSet
		private var _animator:SkeletonAnimator;
		protected var loader3d:AssetLoader
		protected var _mesh:Mesh
		protected var _materialName:String
		private var stateTransition:CrossfadeTransition = new CrossfadeTransition(0.5);
		protected var _meshs:Vector.<Mesh> = new Vector.<Mesh>
		protected var textureBases:Vector.<TextureProxyBase>=new Vector.<TextureProxyBase>
		protected var materialBases:Vector.<MaterialBase>=new Vector.<MaterialBase>
		public function MD53DObject() 
		{
			loader3d = new AssetLoader();
			loader3d.addEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete)
			loader3d.addEventListener(LoaderEvent.LOAD_ERROR,onLoadError)
			loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onAllComplete)
		}		
		private function onAllComplete(e:LoaderEvent):void 
		{
			this.dispatchEvent(e.clone())
		}
		private function onLoadError(e:LoaderEvent):void 
		{
			//加载错误
			this.dispatchEvent(e.clone())
		}		
		private function onAssetComplete(e:AssetEvent):void 
		{
			if (e.asset.assetType == AssetType.TEXTURE)
			{
				textureBases.push(e.asset);
				return;
			}
			if (e.asset.assetType == AssetType.MATERIAL)
			{
				materialBases.push(e.asset);
				return;
			}
			if (e.asset.assetType == AssetType.ANIMATION_SET)
			{
				if (e.asset is SkeletonAnimationSet)
				{
					_animationSet = e.asset as SkeletonAnimationSet;
					_animator = new SkeletonAnimator(_animationSet, _skeleton)
					_mesh.animator = _animator;
				}
				
			}else if (e.asset.assetType == AssetType.SKELETON)
			{
				_skeleton = e.asset as Skeleton;
				
			}else if (e.asset.assetType == AssetType.MESH)
			{
				_mesh = e.asset as Mesh;
				_mesh.mouseEnabled =this.mouseEnabled;
				_meshs.push(_mesh);
				addChild(_mesh);
				if (_animator)_mesh.animator = _animator;
				
			}
			if (e.asset.assetType == AssetType.ANIMATION_NODE) {
				
				var animationNode:SkeletonClipNode = e.asset as SkeletonClipNode;
				if (_animationSet == null)
				{
					_animationSet = new SkeletonAnimationSet()
				}
				_animationSet.addAnimation(animationNode);
				if (_animator == null)
				{
					_animator = new SkeletonAnimator(_animationSet, _skeleton, false)
					_animator.updatePosition = true;
				}
			}
		}
		override public function clone():Object3D 
		{
			var clone:MD53DObject = new MD53DObject(); 
			clone.mesh = this._mesh.clone() as Mesh;
			return clone;
		}
		public function load(url:String):void
		{
			var awps:Array = url.split(".");
			var extension:String = awps[awps.length - 1];
			extension = extension.toLowerCase();
			if (extension == "awp")
			{
				loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete)
				loader3d.addEventListener(AssetEvent.ASSET_COMPLETE,onAWPComplete)
			}
			loader3d.load(new URLRequest(url));
		}		
		private function onAWPComplete(e:AssetEvent):void 
		{
			if (e.asset.assetType == AssetType.TEXTURE)
			{
				textureBases.push(e.asset);
				return;
			}
			if (e.asset.assetType == AssetType.MATERIAL)
			{
				materialBases.push(e.asset);
				return;
			}
			if (e.asset.assetType == AssetType.CONTAINER && e.asset is ParticleGroup)
			{			
				var particleGroup:ParticleGroup = e.asset as ParticleGroup;
				particleGroup.mouseEnabled =this.mouseEnabled;
				addChild(particleGroup);
				particleGroup.animator.start();
				return;
			}
			if (e.asset.assetType == AssetType.MATERIAL)
			{
				(e.asset as MaterialBase).mipmap = false;
			}
			if (e.asset.assetType == AssetType.MESH)
			{
				_mesh = e.asset as Mesh;
				_mesh.mouseEnabled =this.mouseEnabled;				
			}
		}
		public function get skeleton():Skeleton 
		{
			return _skeleton;
		}		
		public function get animationSet():SkeletonAnimationSet 
		{
			return _animationSet;
		}		
		public function get animator():SkeletonAnimator 
		{
			return _animator;
		}		
		public function get mesh():Mesh 
		{
			return _mesh;
		}		
		public function set mesh(value:Mesh):void 
		{
			_mesh = value;
			if (_mesh != null)
			{
				addChild(_mesh)
				if (_mesh.animator)
				{
					_animator = _mesh.animator as SkeletonAnimator;
					_animationSet = _animator.animationSet as SkeletonAnimationSet;
					_skeleton = _animator.skeleton;
				}
			}
		}
		public function getNameMesh(_name:String):Mesh
		{
			var lh:int = _meshs.length;
			for (var i:int = 0; i <lh; i++) 
			{
				if (_meshs[i].name == _name)
				{
					return _meshs[i]
				}
			}
			return null;
		}
		override public function dispose():void 
		{
			trace("MD53DObject::dispose");
			loader3d.stop();
			loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete)
			loader3d.removeEventListener(LoaderEvent.LOAD_ERROR,onLoadError)
			loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onAllComplete)
			loader3d = null		
			var tl:int = textureBases.length;
			for (var i:int = 0; i <tl; i++) 
			{
				textureBases[i].dispose();
				textureBases[i] = null;
			}
			textureBases.length = 0;
			textureBases = null
			
			tl = materialBases.length;
			for (i = 0; i <tl; i++) 
			{
				materialBases[i].dispose();
				materialBases[i] = null;
			}
			materialBases.length = 0;
			materialBases = null;			
			while (numChildren > 0)
			{
				getChildAt(0).disposeAsset();
			}
			_meshs.length = 0;
			_meshs = null;
			if (_skeleton)
			{
				_skeleton.dispose();
				_skeleton = null;
			}
			if (_animationSet)
			{
				_animationSet.dispose();
				_animationSet = null;
			}
			if (_animator)
			{
				_animator.dispose();
				_animator=null
			}
			super.dispose();
		}
		
	}

}